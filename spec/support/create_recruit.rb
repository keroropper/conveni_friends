module CreateRecruit
  def attach_image(name)
    page.execute_script('document.getElementById("img-file").style.display = "";')
    attach_file "img-file", Rails.root.join('spec', 'fixtures', 'files', name)
  end

  def create_recruit(attach: true, file_name: 'kitten.jpg', tags: '', title: "title", explain: "explain", date: Date.tomorrow,
                     meeting_time: "23", required_time: "30分", address: '')
    attach_image(file_name) if attach
    fill_in "recruit_tags", with: tags
    fill_in "recruit_title",	with: title
    fill_in "recruit_explain",	with: explain

    # flatpickrでdateを選択
    find("#date").click
    within(".dayContainer") do
      find(".dayContainer>.flatpickr-day[aria-label='#{date.strftime('%-m月 %-d, %Y')}']").click
    end
    # flatpickrでmeeting_timeを選択
    find("#meeting_time").click
    input_element = find(".numInput.flatpickr-hour")
    input_element.set(meeting_time)

    # googleMap
    map_input = find('input[placeholder="Google マップを検索する"]')
    map_input.set(address)
    map_submit = find('input[value="検索"]')
    map_submit.click if map_input.value.present?

    select required_time,	from: "recruit_required_time"
    click_button "募集"
  end
end
