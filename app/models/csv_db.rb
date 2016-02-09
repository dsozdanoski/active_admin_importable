require 'csv'
class CsvDb
  class << self
    def convert_save(target_model, csv_data, &block)
      parse_data_rows(csv_data) do |data|
        if block_given?
          block.call(target_model, data)
        else
          target_model.create!(data)
        end
      end
    end
    
    def convert_save_with_end_block(target_model, csv_data, &block)
        data_rows = []
        parse_data_rows(csv_data) do |data|
          if block_given?
            data_rows << data
          else
            target_model.create!(data)
          end
        end
        block.call(target_model, data_rows) if block_given?
    end
    
    def parse_data_rows(csv_data, &block)
      csv_file = csv_data.read
      CSV.parse(csv_file, :headers => true, header_converters: :symbol ) do |row|
        data = row.to_hash
        block.call(data) if data.present? && block_given?
      end
    end
  end
end
