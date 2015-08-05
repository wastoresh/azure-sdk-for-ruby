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

require 'azure/autoload'

module Azure

  class << self
    include Azure::Configurable

    # API client based on configured options {Configurable}
    #
    # @return [Azure::Client] API wrapper
    def client(options = {})
      @client = Azure::Client.new(options) unless defined?(@client) && @client.same_options?(options)
      @client
    end

    private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

  end

  Azure.setup
end

# alias of storage module
Azure::Blob = Azure::Storage::Blob
Azure::Table = Azure::Storage::Table
Azure::Queue = Azure::Storage::Queue