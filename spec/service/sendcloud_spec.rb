# encoding: utf-8
require 'spec_helper'

describe "Sendcloud" do
  let(:username) { 'user' }
  let(:password) { 'xxxxtemrejmijfeijixwewe' }

  describe "#to" do
    let(:url) { 'http://www.sendcloud.net/smsapi/send' }
    let(:template_id) { 3126 }
    let(:content) { {} }
    subject { ChinaSMS::Service::Sendcloud.to phone, '', {content: content, template_id: template_id , username: username, password: password} }

    describe 'single phone' do
      let(:phone) { '13601647905' }

      before do
        body = {"phone"=> phone, "vars"=> content.to_json, "msgType"=> '0', "smsUser"=> username, "templateId"=>template_id, "signature"=>"16f795fd3514ed89bdd9fe577fb2601a" }
        stub_request(:post, url).
          with(body:  URI.encode_www_form(body)).
          to_return(body: "{\"info\":{\"successCount\":1,\"smsIds\":[\"1478579653941_49236_566_3126_clrsg5$13601647905\"]},\"statusCode\":200,\"message\":\"请求成功\",\"result\":true}")
      end

      its([:success]) { should eql true }
      its([:code]) { should eql 200 }
      its([:message]) { should eql "请求成功" }
    end
  end

  describe "#get_signature" do
    let(:phone)  { "13601647905" }
    let(:content) { {}.to_json }
    let(:params) { {"phone"=> phone, "vars"=> content, "msgType"=>0, "smsUser"=> username, "templateId"=>3126, 'password'=> password} }
    subject { ChinaSMS::Service::Sendcloud.get_signature params }

    it { should eql "16f795fd3514ed89bdd9fe577fb2601a" }
  end
end
