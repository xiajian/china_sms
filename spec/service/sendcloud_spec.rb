# encoding: utf-8
require 'spec_helper'

describe "Sendcloud" do
  let(:username) { 'user' }
  let(:password) { 'xxxxtemrejmijfeijixwewe' }

  describe "#to" do
    let(:url) { 'http://www.sendcloud.net/smsapi/send' }
    let(:template_id) { 3126 }
    let(:content) { { hostname: 'xiajian.github.com', ip: '192.168.4.56', partition: '/dev/block1', percentage: '80%'} }
    subject { ChinaSMS::Service::Sendcloud.to phone, '', {content: content, template_id: template_id , username: username, password: password} }

    describe 'single phone' do
      let(:phone) { '13601647905' }

      before do
        body = {"phone"=>"13601647905", "vars"=>"{\"hostname\":\"xiajian.github.com/\",\"ip\":\"192.168.4.56\",\"partition\":\"/dev/block1\",\"percentage\":\"80%\"}", "msgType"=>0, "smsUser"=>"postman", "templateId"=>3126, "signature"=>"2812c11a2072b9761b97ddad36112c56"}
        # body = {msgType: 0, phone: "13601647905", signature: "2812c11a2072b9761b97ddad36112c56", smsUser: "postman", templateId: "3126", vars: "{\"hostname\":\"xiajian.github.com/\",\"ip\":\"192.168.4.56\",\"partition\":\"/dev/block1\",\"percentage\":\"80%\"}"}
        stub_request(:post, url).
          with(body:  'phone=13601647905&vars=%7B%22hostname%22%3A%22xiajian.github.com%22%2C%22ip%22%3A%22192.168.4.56%22%2C%22partition%22%3A%22%2Fdev%2Fblock1%22%2C%22percentage%22%3A%2280%25%22%7D&msgType=0&smsUser=postman&templateId=3126&signature=165e7bebe7944788bdc51bfff0328651').
          to_return(body: "{\"info\":{\"successCount\":1,\"smsIds\":[\"1478579653941_49236_566_3126_clrsg5$13601647905\"]},\"statusCode\":200,\"message\":\"请求成功\",\"result\":true}")
      end

      its([:success]) { should eql true }
      its([:code]) { should eql 200 }
      its([:message]) { should eql "请求成功" }
    end
  end

  # describe "get" do
  #   let(:remain_url) { "http://www.smsbao.com/query" }
  #   subject { ChinaSMS::Service::Smsbao.get username: username, password: password }
  #
  #   describe "remain send count" do
  #     before do
  #       stub_request(:post, remain_url).
  #         with(body: {u: username, p: Digest::MD5.hexdigest(password)}).
  #         to_return(body: "0\n100,200")
  #     end
  #
  #     its([:success]) { should eql true }
  #     its([:code]) { should eql '0' }
  #     its([:message]) { should eql '短信发送成功' }
  #     its([:send]) { should eql 100 }
  #     its([:remain]) { should eql 200 }
  #   end
  # end
end
