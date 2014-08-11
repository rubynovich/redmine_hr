# encoding: UTF-8
namespace :redmine do
  namespace :plugins do
    namespace :hr_candidates do

        desc 'Change candidates status to another. Remove some statuses'
        # rake redmine:plugins:hr_candidates:hr_candidates_change_statuses            
        task :hr_candidates_change_statuses => :environment do
			h = {
				"Отправлено письмо" => "Рассмотреть резюме",
				"Отправить письмо с предложением вакансии." => "Рассмотреть резюме",
				"На контроле" => "Связаться с кандидатом",
				"Телефонное интервью" => "Провести собеседование в HR",
				"Видео-интервью" => "Провести собеседование в HR",
				"Отказ кандидата после предложения о работе" => "Отказ кандидата",
				"отказ кандидата на этапе телефонного интерью" => "Отказ кандидата",
				"резерв" => "Резерв",
				"Сделано предложение о работе" => "Сформировать предложение о работе",
				"Выходит в СтройТорги (менеджер - Юркина А.)" => "",
				"Выходит в СтройТорги (менеджер - Хан Л.)" => "Вывести кандидата на работу (менеджер - Хан Л.)",
				"Выходит в Стройторги (Малинковская)" => "Вывести кандидата на работу (менеджер - Малинковская И.)",
				"Выходит (Малинковская)" => "Вывести кандидата на работу (менеджер - Малинковская И.)",
				"Выходит (И Малинковская)" => "Вывести кандидата на работу (менеджер - Малинковская И.)",
				"Выходит в Стройторги" => "Вывести кандидата на работу",
				"Выходит взамен уволенного" => "",
				"На рассмотрении" => ""
			}
			h.each_pair do |h_old, h_new| 
				if h_new != ""
					new_id = HrStatus.where(name: h_new).pluck(:id).first
					if new_id.blank?
						HrStatus.create(name: h_new) 
						puts "For name " + h_new + " there is no values. Created new one"
					end
					HrCandidate.joins(:hr_status).where([%{#{HrStatus.table_name}.name = ?}, h_old]).each {|c| c.update_column(:hr_status_id, new_id)} 
				end
				HrStatus.where(name: h_old).first.delete if HrStatus.where(name: h_old).first && HrCandidate.joins(:hr_status).where([%{#{HrStatus.table_name}.name = ?}, h_old]).count == 0
			end

            
        end
    end
  end
end