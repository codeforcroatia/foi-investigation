module IncidentsHelper

  # Creates a link to the Right To Know new request form. It populates the form
  # with incident specific details. It also populates the form with tags that
  # can later be used for tracking requests
  def link_to_right_to_know_form(incident, text=nil)
    url = "http://imamopravoznati.org/new/#{ incident.location.geoloc }/?title=#{incident.incident_number};" +
      "body=Za:%20#{ incident.incident_number  }" +
      "%2C%0A%0APod%20Zakonom%20o%20pravu%20na%20pristup%20informacijama%20molim%20vas%20podatke%20" +
      "sadrzane%20u%20'#{ incident.incident_number }'.%20Dostavite%20sljede%C4%87e%20" +
      "informacije%3A%0A%0A%20#{ incident.incident_number }%20" +
      "%0A%0ALijep%20pozdrav%2C%0A%0A****OVDJE%20SE%20POTPISI%20PUNIM%20IMENOM%20PRIJE%20SLANJA****" +
      "&tags=" + u("detentionlogs incident-number:#{incident.incident_number}")
    text ||= "Preuzmi #{incident.incident_number}"
    title =  "Otvara unaprijed popunjeni zahtjev za pristup informacijama putem ImamoPravoZnati alata"
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
      text = "PPI zahtjev za vise detalja: #{foi_request.display_status}"
      link = "http://imamopravoznati.org/request/#{foi_request.url_title}"
    else
      statuses = incident.foi_requests.map(&:display_status).uniq
      text = "#{incident.foi_requests.length} PPI zahtjev: #{statuses.to_sentence.gsub('.', '')}"
      link = "http://imamopravoznati.org/search/#{incident.incident_number}"
    end

    link_to text, link, { class: "incident-rtk-request-link"}
  end
end