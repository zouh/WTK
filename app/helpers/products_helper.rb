module ProductsHelper
  def image_for(product, options = { size: '100' })
    image_tag(product.image_url, alt: product.name, size: options[:size], class: "gravatar")
  end
end
