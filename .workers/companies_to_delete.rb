require_relative "../app"

Ost[:companies_to_delete].each do |id|
  CompanyRemover.remove(Company[id])
end
