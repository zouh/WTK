module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    email = user.nil? ? 'example-10@railstutorial.org' : user.email.downcase
    gravatar_id = Digest::MD5::hexdigest(email)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    name = user.nil? ? '' : user.name
    image_tag(gravatar_url, alt: name, class: "gravatar")
  end

  def qrcode_for(user, options = { size: 50 })
    img_name = "u" + user.id.to_s + ".png"
    invite_code = user.member.nil? ? "http://wtk.meeket.com/signup" : user.member.invite_code
    size = options[:size] * 3
    png = RQRCode::QRCode.new(invite_code, size: 4, level: :h).to_img.resize(size, size)

    url = "./app/assets/images/" + img_name
    png.save(url)
    name = user.nil? ? '' : user.name
    image_tag(img_name, alt: name, class: "gravatar")
  end

  def invite_code_for(user)
  	@user.member.invite_code unless @user.member.nil?
  end

  def organization_of(user)
    mb &&= @user.member
    org &&= mb.organization
  end

end