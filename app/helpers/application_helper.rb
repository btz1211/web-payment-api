module ApplicationHelper
  def convert_error_hash_to_array(error_object)
    errors = []

    error_object.each do |key|
      error_object[key].each do |attr_error|
        errors.push("#{key}: #{attr_error}")
      end
    end

    errors
  end
end
