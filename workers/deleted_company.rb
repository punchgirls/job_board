require_relative "../app"

Ost[:deleted_company].each do |id|
  CompanyRemover.remove(Company[id])
end
