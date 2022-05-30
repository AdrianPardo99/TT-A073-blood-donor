#!/usr/bin/env  ruby

require 'time'
require 'date'
def validate_types(unit)
    types = ["ST","CE","CP","PF","PDFL","CRIO"]
    if types.include?(unit)
        return true
    end
    return false
end

if ARGV.length<4
    puts "Error ussage $0 <quantity_blood_sample> <quantity> <unit_type> <list_centers_id>"
    exit 1
end
qty_sample=ARGV[0].to_i
qty=ARGV[1].to_i
type=ARGV[2]
list=ARGV[3].split(",").map{|i| i.to_i}

if !validate_types(type)
    perror "Please use a valid unit type"
    puts "Example: ST, CE, CP, PF, PDFL, CRIO"
    exit 1
end

expirations = {"ST"=>30,"CE"=>30,"CP"=>6,"PF"=>182,"PDFL"=>365,"CRIO"=>365}

fecha=Time.now.strftime("%d-%m-%Y_%H-%M")
archivo=File.open("#{type}-#{fecha}.txt","w")

expiration= expirations[type]
archivo.write("Creando datos:\nimport datetime\nfrom blood_center.models import Center, Unit\n")
list.length.times{|i|
    archivo.write("center_#{i}=Center.objects.get(pk=#{list[i]})\n")
}

date_1 = DateTime.now()
date_2 = DateTime.now().next_day(10)
bloods = ["a+","a-","b+","b-","ab+","ab-","o+","o-"]
genders = ["m","f","o"]
qty.times{|i|
    center=rand(0..(list.length-1))
    blood_type = bloods[rand(0..(bloods.length-1))]
    date=rand(date_1..date_2)
    created_at="datetime.datetime(#{date.year},#{date.month},#{date.day},#{date.hour},#{date.min},#{date.sec})"
    expired = date.next_day(expiration)
    expired_at="datetime.date(#{expired.year},#{expired.month},#{expired.day})"
    is_altruist = rand(0..1)==1
    age = rand(18..60)
    gender = genders[rand(0..(genders.length-1))]
    vals = "{'created_at':#{created_at},'center':center_#{center},'type':'#{type}','blood_type':'#{blood_type}','expired_at':#{expired_at},'is_altruist_unit':#{is_altruist.to_s.capitalize},'donor_gender':'#{gender}','donor_age':#{age}}"
    archivo.write("Unit.objects.create(**#{vals})\n")

}

archivo.close