module IncidentsHelper

  # Creates a link to the Right To Know new request form. It populates the form
  # with incident specific details. It also populates the form with tags that
  # can later be used for tracking requests
  def link_to_right_to_know_form(incident, text=nil)
    url = "http://imamopravoznati.org/new/#{ incident.location.geoloc }/?title=#{incident.incident_number};" +
      "body=Za:%20#{ incident.location.name }%2C%0A%0APo%C5%A1tovani%2C%0A%0A" +
      "%2C%0A%0APod%20Zakonom%20o%20pravu%20na%20pristup%20informacijama%20molim%20vas%20dostavite%20ljede%C4%87e%20" +
      "informacije%3A%0A%0A%20#{ incident.incident_description }.%20" +
      "Dostavite%20na%20ovu%20adresu%20u%20digitalnom%20obliku%20." +
      "%0A%0ALijep%20pozdrav%2C%0A%0A****OVDJE%20NAVEDITE%20IME%20I%20PREZIME%20PRIJE%20SLANJA%20ZAHTJEVA****" +
      "&tags=" + u("detentionlogs incident-number:#{incident.incident_number}")
    text ||= "Preuzmi #{incident.incident_number}"
    title =  "Otvara unaprijed popunjeni zahtjev za pristup informacijama kori&#353;tenjem Imamo pravo znati alata"
    link_to text, url, { title: title, class: "btn btn-submit"}
  end

  # Creates html class(s) for use in the display of
  # notices about the status of requests
  def foi_request_state_class(incident)
    state = incident.foi_requests.map(&:described_state).uniq.join(" foi_state_")
    "foi_state_" + state
  end

  # Creates a link to the Right To Know request
  def link_to_right_to_know(incident)
    if (incident.foi_requests.count == 1)
      foi_request = incident.foi_requests.first
      text = "PPI zahtjev za vi&#353;e detalja: #{foi_request.display_status}"
      link = "http://imamopravoznati.org/request/#{foi_request.url_title}"
    else
      statuses = incident.foi_requests.map(&:display_status).uniq
      text = "#{incident.foi_requests.length} PPI zahtjev za vi&#353;e detalja: #{statuses.to_sentence.gsub('.', '')}"
      link = "http://imamopravoznati.org/search/#{incident.incident_number}"
    end

    link_to text, link, { class: "incident-rtk-request-link"}
  end
end
