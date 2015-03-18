module ProductsHelper

  def image_for(product, options = { size: '100' })
    image_tag(product.image_url, alt: product.name, size: options[:size], class: "gravatar")
  end

  def qrcode_for_product(product, options = { size: 50 })
    img_name = "u" + product.id.to_s + ".png"
    product_url = "http://wtk.meeket.com/products/" + product.id.to_s
    size = options[:size] * 3
    png = RQRCode::QRCode.new(product_url, size: 4, level: :h).to_img.resize(size, size)

    url = "./app/assets/images/" + img_name
    png.save(url)
    name = product.nil? ? '' : product.name
    image_tag(img_name, alt: name, class: "gravatar")
  end

end
