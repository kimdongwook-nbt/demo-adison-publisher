require 'rails_helper'

RSpec.describe "Api::Offerwall::Offerwalls", type: :request do
  before(:example) do
    @params = {
      trx_id: "test_trx_id",
      click_key: "test_click_key",
      uid: "test_uid_hash",
      advertising_id: "test_advertising_id",
      client_platform_type: 1,
      campaign_id: 1,
      ad_id: 1,
      event_code: "__default__",
      ad_title: "ad_title",
      event_title: nil,
      reward: 10,
      language: "en",
      country: "US"
    }

    @given_hmac_time = "2023-12-28T10:00:00+00:00"
    @given_request_uri = "/api/offerwall/completeCampaign"

    @headers = {
      REQUEST_METHOD: "POST",
      REQUEST_URI: @given_request_uri,
      X_HMAC_DATETIME: @given_hmac_time,
      X_HMAC_SIGNATURE: "NmVkOGVkMTNhNzcwNTUyZTMwZThhMjcyYmI5ODg3ZGJiODJlODhhNzY4N2QxODVjNDMyMjVkYWNjMTA0NmZmYg==",
      RAW_POST_DATA: @params.to_json,
      QUERY_STRING: ""
    }

    User.create(
      email: "user@mail.com",
      name: "user",
      uid_hash: "test_uid_hash",
      reward: 0
    )
  end

  describe "유저 리워드 적립 실패에 대한 테스트" do
    it 'HMAC 인증 실패 시 status: 200, { code: 101, message: HMAC 인증 오류 } 를 응답한다.' do
      # given
      @headers[:X_HMAC_SIGNATURE] = "wrong signature"

      # when
      post "/api/offerwall/completeCampaign", :params => @params, :headers => @headers

      # then
      expect(response.status).to eq 200
      expect(response.body).to match(/101/)
      expect(response.body).to match(/HMAC\s인증\s오류/)
      expect(User.find_by_email("user@mail.com").reward).to eq 0
    end

    it '파라미터 오류 (ex: click_key = nil) 인 경우 status: 200, { code: 101, message: 파라미터 오류 } 를 응답한다.' do
      # given
      @params[:click_key] = nil

      # when
      post "/api/offerwall/completeCampaign", :params => @params, :headers => @headers

      # then
      expect(response.status).to eq 200
      expect(response.body).to match(/102/)
      expect(response.body).to match(/파라미터\s오류/)
      expect(User.find_by_email("user@mail.com").reward).to eq 0
    end

    it '올바르지 않은 Uid 가 요청된 경우 status: 200, { code: 103, message: 올바르지 않은 uid } 를 응답한다.' do
      # given
      @params[:uid] = "wrong_uid_hash"

      # when
      post "/api/offerwall/completeCampaign", :params => @params, :headers => @headers

      # then
      expect(response.status).to eq 200
      expect(response.body).to match(/103/)
      expect(response.body).to match(/올바르지\s않은\suid/)
      expect(User.find_by_email("user@mail.com").reward).to eq 0
    end

    it '중복된 trx_id 요청 시 status: 200, { code: 104, message: 중복호출 } 를 응답한다.' do
      # given
      post "/api/offerwall/completeCampaign", :params => @params, :headers => @headers

      # when
      post "/api/offerwall/completeCampaign", :params => @params, :headers => @headers

      # then
      expect(response.status).to eq 200
      expect(response.body).to match(/104/)
      expect(response.body).to match(/중복 호출/)
      expect(User.find_by_email("user@mail.com").reward).to eq 10
    end

    it '중복된 click_key + event_code 요청 시 status: 200, { code: 104, message: 중복호출 } 를 응답한다.' do
      # given
      post "/api/offerwall/completeCampaign", :params => @params, :headers => @headers

      params = {}
      params.merge!(@params)
      params[:trx_id] = "test_trx_id_2"

      headers = {}
      headers.merge!(@headers)
      hmac_util = HmacUtil.new(HmacUtil::SupportAlgorithm::SHA256)
      signature = hmac_util.signature("POST", "/api/offerwall/completeCampaign", @given_hmac_time, "", params.to_json)
      headers[:X_HMAC_SIGNATURE] = signature
      headers[:RAW_POST_DATA] = params.to_json

      # when
      post "/api/offerwall/completeCampaign", :params => params, :headers => headers

      # then
      expect(response.status).to eq 200
      expect(response.body).to match(/104/)
      expect(response.body).to match(/중복 호출/)
      expect(User.find_by_email("user@mail.com").reward).to eq 10
    end

    it "reward 가 0 이하인 경우 status: 200, { code: 400, message: invalid reward } 를 응답한다." do
      # given
      params = {}
      params.merge!(@params)
      params[:reward] = -1

      headers = {}
      headers.merge!(@headers)
      hmac_util = HmacUtil.new(HmacUtil::SupportAlgorithm::SHA256)
      signature = hmac_util.signature("POST", @given_request_uri, @given_hmac_time, "", params.to_json)
      headers[:X_HMAC_SIGNATURE] = signature
      headers[:RAW_POST_DATA] = params.to_json

      # when
      post "/api/offerwall/completeCampaign", :params => params, :headers => headers

      # then
      expect(response.status).to eq 200
      expect(response.body).to match(/400/)
      expect(response.body).to match(/기타 오류/)
      expect(User.find_by_email("user@mail.com").reward).to eq 0
    end

    it "client_platform_type 이 3인 경우 status: 200, { code: 400, message: invalid client_platform_type } 를 응답한다." do
      # given
      params = {}
      params.merge!(@params)
      params[:client_platform_type] = 3

      headers = {}
      headers.merge!(@headers)
      hmac_util = HmacUtil.new(HmacUtil::SupportAlgorithm::SHA256)
      signature = hmac_util.signature("POST", @given_request_uri, @given_hmac_time, "", params.to_json)
      headers[:X_HMAC_SIGNATURE] = signature
      headers[:RAW_POST_DATA] = params.to_json

      # when
      post "/api/offerwall/completeCampaign", :params => params, :headers => headers

      # then
      expect(response.status).to eq 200
      expect(response.body).to match(/400/)
      expect(response.body).to match(/기타 오류/)
      expect(User.find_by_email("user@mail.com").reward).to eq 0
    end
  end

  describe "유저 리워드 적립 성공에 대한 테스트" do
    it '적립 요청 성공 시 status: 200, { code: 200, message: "success", issued_key } 를 응답한다.' do
      # when
      post "/api/offerwall/completeCampaign", :params => @params, :headers => @headers

      # then
      expect(response.status).to eq 200
      expect(response).to match_json_schema("success")
      expect(User.find_by_email("user@mail.com").reward).to eq 10
    end
  end
end
