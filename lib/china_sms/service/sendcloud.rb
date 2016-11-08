# encoding: utf-8
module ChinaSMS
  module Service
    module Sendcloud
      extend self

      URL = 'http://www.sendcloud.net/smsapi/send'.freeze

      MESSAGES = {
          '500' => '发送失败, 手机空号',
          '510' => '发送失败, 手机停机',
          '550' => '发送失败, 该模板内容被投诉',
          '580' => '发送失败, 手机关机',
          '590' => '发送失败, 其他原因',
          '200' => '请求成功',
          '311' => '部分号码请求成功',
          '312' => '全部请求失败',
          '411' => '手机号不能为空',
          '412' => '手机号格式错误',
          '413' => '有重复的手机号',
          '421' => '签名参数错误',
          '422' => '签名错误',
          '431' => '模板不存在',
          '432' => '模板未提交审核或者未审核通过',
          '433' => '模板ID不能为空',
          '441' => '替换变量格式错误',
          '451' => '定时发送时间的格式错误',
          '452' => '定时发送时间早于服务器时间, 时间已过去',
          '461' => '时间戳无效, 与服务器时间间隔大于6秒',
          '471' => 'smsUser不存在',
          '472' => 'smsUser不能为空',
          '473' => '没有权限, 免费用户不能发送短信',
          '474' => '用户不存在',
          '481' => '手机号和替换变量不能为空',
          '482' => '手机号和替换变量格式错误',
          '483' => '替换变量长度不能超过32个字符',
          '496' => '一分钟内给当前手机号发信太多',
          '498' => '一天内给当前手机号发信太多',
          '499' => '账户额度不够',
          '501' => '服务器异常',
          '601' => '你没有权限访问'
      }

      module MSG_TYPE
        SMS = 0

        MMS = 1
      end

      def get_signature(params)
        param_str = []
        password = params.delete 'password'
        params.keys.sort.each do |key|
          param_str << "#{key}=#{params[key]}"
        end

        sign_str = "#{password}&#{param_str.join('&')}&#{password}"

        Digest::MD5.hexdigest sign_str
      end

      def to(phone, content = '', options = {})
        options[:type] ||= MSG_TYPE::SMS

        params = {
            'phone' => phone,
            'vars' => options[:content].to_json,
            'msgType' => options[:type],
            'smsUser' => options[:username],
            'templateId' => options[:template_id],
            'password' => options[:password]
        }

        params.merge! 'signature' => get_signature(params)

        puts "Request params: #{params}"

        res = Net::HTTP.post_form(URI.parse(URL), params)

        puts "Response Body: #{res.body}"

        result JSON.parse(res.body)
      end

      def result(response)
        code = response['statusCode']

        {
            success: (code == 200),
            code: code,
            message: response['message']
        }
      end
    end
  end
end
