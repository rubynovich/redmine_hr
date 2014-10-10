# encoding: UTF-8
namespace :redmine do
  namespace :plugins do
    namespace :hr_candidates do

        def update_one_phone(hr, some_phones)
            unless some_phones.blank?
                some_phones.sub!(/;\s+/, ", ")
                arr = some_phones.split(/,\s*\+*/)
                new_phones = ""
                arr.each do |phone|
                    old_phone = phone.dup
                    
                    phone.gsub!(/[^\+0-9\(\)\/]/, '')
                    phone.insert(0, '+7') if (phone.size == 10) && (phone.index(/[^\d]/) == nil)
#puts "6:     _" + phone
                    phone.gsub!(/\+/, "+7") if phone.include?("+") && !phone.include?("+7") && !phone.include?("+8")
                    phone.insert(0, '+') if (phone[0] == "8") || (phone[0] == "7")
                    phone[1] = "7" if (phone[0] == "+")
                    
                    #puts "7:     _" + phone
                    if phone.include?("+7") && phone[2] != "("
                        phone.gsub!(/\+7/, "+7 (")
                        phone.insert(7, ') ') if phone.size > 6
                    elsif phone.include?("+7")
                        phone.gsub!(/\(/, " (")
                        phone.gsub!(/\)/, ") ")
                    end                        
                    phone.insert(12, '-') if phone.size > 11
                    phone.insert(15, '-') if phone.size > 14
                  
                    new_phones << ", " unless new_phones.blank?
                    if phone.size == 18 
                        new_phones << phone
                    else
                        new_phones << old_phone
                    end

                end
                hr.phone = new_phones                 
                
            end
        end

        def concat_duplicates(some_phone)
            return false if some_phone.blank?
            arr = some_phone.split(/,\s+/).uniq
            new_phone = ""
            arr.each do |phone|
                new_phone << ", " unless new_phone.blank?
                new_phone << phone
            end
            new_phone
        end


        desc 'Update phone with template +7 (XXX) XXX-XX-XX in redmine_hr_candidates'
        # rake redmine:plugins:hr_candidates:hr_candidates_update_phone            
        task :hr_candidates_update_phone => :environment do
            HrCandidate.all.each do |c|
                next if c.phone.blank? 
                phonee = c.phone.dup
                update_one_phone(c, c.phone)
                c.phone = concat_duplicates(c.phone)

                c.save!(:validate => false)

                if c.phone.blank? || c.phone.size != 18
                    puts c.id.to_s+ "  phones: _" + (phonee.blank? ? "" : phonee)  + "_    _" + (c.phone.blank? ? "" : c.phone) 
                end

                #puts "---------------------------------" 
                
            end
            HrCandidate.where("(LENGTH(phone) < 5) AND (LENGTH(phone) > 0)").update_all(phone: nil)
        end

        desc 'Set sanitized_phones from phones'
        # rake redmine:plugins:hr_candidates:hr_candidates_sanitized_phones            
        task :hr_candidates_sanitized_phones => :environment do
            HrCandidate.all.each do |c|
                next if c.phone.blank?      
                c.sanitized_phones = c.phone.gsub(/[^0-9,]/, '')
                c.update_column(:sanitized_phones, c.sanitized_phones)                           
                puts c.id.to_s+ "  phones: _" + c.phone + "_    _" + c.sanitized_phones + "_    "
            end
        end
    end
  end
end