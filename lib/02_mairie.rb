require 'rubygems'
require 'nokogiri'
require 'open-uri'


# RECUPERER L'ADRESSE EMAIL D'UNE VILLE 
def get_townhall_email(townhall_url)
  page = Nokogiri::HTML(URI.open(townhall_url))
  return page.xpath('//tbody/tr[4]/td[2]').slice(0).text
end

# RECUPERER LA LISTE DES URLS DE CHAQUE VILLE
def get_townhall_urls(townhall_list)
  page = Nokogiri::HTML(URI.open(townhall_list))
  annuaire = []
  page.xpath('//a[@class="lientxt"]/@href').each do |link|
    annuaire << link.text
  end
  annuaire.map!{ |x| ["https://www.annuaire-des-mairies.com", x.reverse.chop.reverse].join}
  return annuaire
end

# RECUPERER LA LISTE DES NOMS DE CHAQUE VILLE
def get_townhall_names(townhall_list)
  page = Nokogiri::HTML(URI.open(townhall_list))
  annuaire = []
  page.xpath('//a[@class="lientxt"]').each do |link|
    annuaire << link.text
  end
  return annuaire
end

# RECUPERER LA LISTE DES ADRESSES EMAILS DE CHAQUE MAIRIE
def get_townhalls_emails()

  annuaire_emails_val_doise = []
  get_townhall_urls('https://www.annuaire-des-mairies.com/val-d-oise.html').each do |link|
    annuaire_emails_val_doise << get_townhall_email(link)
  end
  
  annuaire_villes_val_doise = get_townhall_names('https://www.annuaire-des-mairies.com/val-d-oise.html')
  
  hash_annuaire = annuaire_villes_val_doise.zip(annuaire_emails_val_doise).to_h
  array_of_hashes = hash_annuaire.each_slice(1).map &:to_h  
  return array_of_hashes
end

puts get_townhalls_emails
