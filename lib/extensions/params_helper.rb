module ParamsHelper

  # TODO: this seems to be exactly the same as app/helpers/params_helper.rb
  # Do we really need both?
  def extract_choice_attribute_arrays_from params
    images = params[:image_url_list].split("<OPTION>")
    titles = params[:title_list].split("<OPTION>")
    infos = params[:info_list].split("<OPTION>")
    service_ids = params[:id_list].split("<OPTION>")
    length = images.length
    {images: images, titles: titles, infos: infos, service_ids: service_ids, length: length}
  end
end
