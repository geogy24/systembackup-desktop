# frozen_string_literal: true

require 'rubygems'
require 'date'
require 'rbase'

# write a DBF record
# @date 03/01/2019
# @author github @geogy24
class Dbf
  RECORDAT_PATH = "#{Shared::APP_CONFIG[:production][:path_install]}\\recordat"

  def self.write_record
    RBase::Table.open RECORDAT_PATH do |t|
      t.create id: count_records,
               fecha: DateTime.now.to_date,
               mensaje: 'No se pudo realizar la copia de seguridad.',
               id2: '**TODOS',
               id_origen2: user_id,
               Dias: 5,
               fechorenv: DateTime.now.to_date
    end
  end

  def self.count_records
    RBase::Table.open(RECORDAT_PATH).count
  end

  def self.user_id
    user_id = ''
    Shared::APP_CONFIG[:production][:folders].each do |folder|
      next unless folder['source_folder'].include?('datos')

      RBase::Table.open "#{Shared::APP_CONFIG[:production][:path_install]}\\" \
        "#{folder['source_folder']}\\usuarios" do |t|
        t.each { |r| user_id = r.id if r.super == 1 }
      end
    end
    user_id
  end
end
