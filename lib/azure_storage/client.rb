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

require 'azure/http_client'

require 'azure_storage/core'
require 'azure_storage/core/client_options'

require 'azure_storage/blob/blob_service'
require 'azure_storage/table/table_service'
require 'azure_storage/queue/queue_service'
# require 'azure_storage/file/file_service'

module Azure::Storage
  class Client
    include Azure::Storage::ClientOptions
    include Azure::HttpClient

    # Public: Creates an instance of [Azure::Storage::Client]
    #
    # ==== Attributes
    #
    # * +options+    - Hash. Optional parameters.
    #
    # ==== Options
    #
    # Accepted key/value pairs in options parameter are:
    #
    # * +:use_development_storage+        - TrueClass. Whether to use storage emulator.
    # * +:development_storage_proxy_uri+  - String. Used with +:use_development_storage+ if emulator is hosted other than localhost.
    # * +:storage_account_name+           - String. The name of the storage account.
    # * +:storage_access_key+             - Base64 String. The access key of the storage account.
    # * +:storage_sas_token+              - String. The signed access signiture for the storage account or one of its service.
    # * +:storage_blob_host+              - String. Specified Blob serivce endpoint or hostname
    # * +:storage_table_host+             - String. Specified Table serivce endpoint or hostname
    # * +:storage_queue_host+             - String. Specified Queue serivce endpoint or hostname
    # * +:storage_dns_suffix+             - String. The suffix of a regional Storage Serivce, to
    # * +:default_endpoints_protocol+     - String. http or https
    # * +:use_path_style_uri+             - String. Whether use path style URI for specified endpoints
    # * +:ca_file+                        - String. File path of the CA file if having issue with SSL
    #
    # The valid set of options inlcude:
    # * Storage Emulator: +:use_development_storage+ required, +:development_storage_proxy_uri+ optionally
    # * Storage account name and key: +:storage_account_name+ and +:storage_access_key+ required, set +:storage_dns_suffix+ necessarily
    # * Storage account name and SAS token: +:storage_account_name+ and +:storage_sas_token+ required, set +:storage_dns_suffix+ necessarily
    # * Specified hosts and SAS token: At least one of the service host and SAS token. It's up to user to ensure the SAS token is suitable for the serivce
    # * Anonymous Blob: only +:storage_blob_host+, if it is to only access blobs within a container
    #
    # Additional notes:
    # * Specified hosts can be set when use account name with access key or sas token
    # * +:default_endpoints_protocol+ can be set if the scheme is not specified in hosts
    # * Storage emulator always use path style URI
    # * +:ca_file+ is independent.
    #
    # When empty options are given, it will try to read settings from Environment Variables. Refer to [Azure::Storage::ClientOptions.env_vars_mapping] for the mapping relationship
    #
    # @return [Azure::Storage::Client]
    def initialize(options = {})
      reset!(options)
    end

    # Azure Blob service configured from this Azure Storage client instance
    # @return [Azure::Storage::Blob::BlobService]
    def blobs(options = {})
      @blobs ||= Azure::Blob::BlobService.new(default_client(options))
    end

    # Azure Queue service configured from this Azure Storage client instance
    # @return [Azure::Storage::Queue::QueueService]
    def queues(options = {})
      @queues ||= Azure::Queue::QueueService.new(default_client(options))
    end

    # Azure Table service configured from this Azure Storage client instance
    # @return [Azure::Storage::Table::TableService]
    def tables(options = {})
      @tables ||= Azure::Table::TableService.new(default_client(options))
    end

    class << self

      # Public: Creates an instance of [Azure::Storage::Client]
      #
      # ==== Attributes
      #
      # * +options+    - Hash. Optional parameters.
      #
      # ==== Options
      #
      # Accepted key/value pairs in options parameter are:
      #
      # * +:use_development_storage+        - TrueClass. Whether to use storage emulator.
      # * +:development_storage_proxy_uri+  - String. Used with +:use_development_storage+ if emulator is hosted other than localhost.
      # * +:storage_account_name+           - String. The name of the storage account.
      # * +:storage_access_key+             - Base64 String. The access key of the storage account.
      # * +:storage_sas_token+              - String. The signed access signiture for the storage account or one of its service.
      # * +:storage_blob_host+              - String. Specified Blob serivce endpoint or hostname
      # * +:storage_table_host+             - String. Specified Table serivce endpoint or hostname
      # * +:storage_queue_host+             - String. Specified Queue serivce endpoint or hostname
      # * +:storage_dns_suffix+             - String. The suffix of a regional Storage Serivce, to
      # * +:default_endpoints_protocol+     - String. http or https
      # * +:use_path_style_uri+             - String. Whether use path style URI for specified endpoints
      # * +:ca_file+                        - String. File path of the CA file if having issue with SSL
      #
      # The valid set of options inlcude:
      # * Storage Emulator: +:use_development_storage+ required, +:development_storage_proxy_uri+ optionally
      # * Storage account name and key: +:storage_account_name+ and +:storage_access_key+ required, set +:storage_dns_suffix+ necessarily
      # * Storage account name and SAS token: +:storage_account_name+ and +:storage_sas_token+ required, set +:storage_dns_suffix+ necessarily
      # * Specified hosts and SAS token: At least one of the service host and SAS token. It's up to user to ensure the SAS token is suitable for the serivce
      # * Anonymous Blob: only +:storage_blob_host+, if it is to only access blobs within a container
      #
      # Additional notes:
      # * Specified hosts can be set when use account name with access key or sas token
      # * +:default_endpoints_protocol+ can be set if the scheme is not specified in hosts
      # * Storage emulator always use path style URI
      # * +:ca_file+ is independent.
      #
      # When empty options are given, it will try to read settings from Environment Variables. Refer to [Azure::Storage::ClientOptions.env_vars_mapping] for the mapping relationship
      #
      # @return [Azure::Storage::Client]
      def create(options={})
        Client.new(options)
      end

      # Public: Creates an instance of [Azure::Storage::Client] with Storage Emulator
      #
      # ==== Attributes
      #
      # * +proxy_uri+    - String. Used with +:use_development_storage+ if emulator is hosted other than localhost.
      #
      # @return [Azure::Storage::Client]
      def create_development(proxy_uri=nil)
        proxy_uri ||= StorageServiceClientConstants::DEV_STORE_URI
        create(:use_development_storage => true, :development_storage_proxy_uri => proxy_uri)
      end


      # Public: Creates an instance of [Azure::Storage::Client] from Environment Variables
      #
      # @return [Azure::Storage::Client]
      def create_from_env
        create
      end

      # Public: Creates an instance of [Azure::Storage::Client] from Environment Variables
      #
      # ==== Attributes
      #
      # * +connection_string+    - String. Please refer to https://azure.microsoft.com/en-us/documentation/articles/storage-configure-connection-string/.
      #
      # @return [Azure::Storage::Client]
      def create_from_connection_string(connection_string)
        Client.new(connection_string)
      end
    end

    private

    def default_client(opts)
      {client: self}.merge(opts || {})
    end

  end
end
