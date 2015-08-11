#-------------------------------------------------------------------------
# # Copyright (c) Microsoft and contributors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#--------------------------------------------------------------------------

require 'rubygems'
require 'nokogiri'
require 'base64'
require 'openssl'
require 'uri'
require 'rexml/document'
require 'addressable/uri'
require 'faraday'
require 'faraday_middleware'

require 'azure_storage/autoload'

module Azure
  module Storage
    class << self

      def setup(options={})
        @client = Azure::Storage::Client.new(options)
      end

      def client
        @client
      end

      private

      def method_missing(method_name, *args, &block)
        return Azure::Storage::Client.send(method_name, *args, &block) if Azure::Storage::Client.respond_to?(method_name)
        return @client.send(method_name, *args, &block) if defined? @client && client.respond_to?(method_name)
        super
      end

    end
  end
end
