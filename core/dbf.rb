require 'rubygems'
require 'date'
require 'rbase'

# write a DBF record
# @date 03/01/2019
# @author github @geogy24
class Dbf
  def self.write_record
    RBase.Table.open "#{Shared::APP_CONFIG[:production][:path_install]}\\recordat" do |t|
      t.create name: 'People-1', birthdate: Date.new(2017,1,2), active: true, tax: 5.2
    end
  end
end
