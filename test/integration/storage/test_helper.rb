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
require 'test_helper'
require 'azure'

Azure.configure do |config|
  config.storage_access_key       = ENV.fetch('AZURE_STORAGE_ACCESS_KEY')
  config.storage_account_name     = ENV.fetch('AZURE_STORAGE_ACCOUNT')
end

util = Class.new.extend(Azure::Core::Utility)

StorageAccountName = util.random_string('storagetest',10)