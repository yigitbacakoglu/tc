module BaseHelper
  # rating_for(@object)
  def rating_for(rateable_obj, options={})

    rateable_obj.ratings.build if rateable_obj.ratings.blank?
    category = rateable_obj.rating_category
    options['max_value'] ||= category.max_value
    self.send(category.name.to_sym, rateable_obj, options) if self.respond_to?(category.name.to_sym)

  end

  def thumb(rateable_obj, options)
    rating_max_value = options['max_value']
    up_votes = rateable_obj.ratings.where("( value / max_value ) > 0.5").count
    down_votes = rateable_obj.ratings.where("( value / max_value ) <= 0.5").count
    avg_rate = number_with_precision rateable_obj.avg_rate, :precision => 2
    content_tag :div, "", :class => "thumbs_container", :id => "#{rateable_obj.class.name.to_s.downcase}_#{rateable_obj.id}", "data-rating" => avg_rate,
                "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name.to_s.downcase,
                "data-star-count" => rating_max_value, "data-url" => options[:url] do

      "#{link_to_with_icon 'icon-hand-up icon-medium rate_thumb', "", '#', 'data-value' => '2'} <span class='up'>#{up_votes.to_s}</span> #{link_to_with_icon 'icon-hand-down icon-medium rate_thumb', "", '#', 'data-value' => '1'} <span class='down'>#{down_votes}</span>".html_safe
    end

  end


  def vote(rateable_obj, options)
    rating_max_value = options['max_value']
    up_votes = rateable_obj.ratings.where("( value / max_value ) > 0.5").count
    down_votes = rateable_obj.ratings.where("( value / max_value ) <= 0.5").count
    avg_rate = number_with_precision rateable_obj.avg_rate, :precision => 2
    content_tag :div, "", :class => "thumbs_container", :id => "#{rateable_obj.class.name.to_s.downcase}_#{rateable_obj.id}", "data-rating" => avg_rate,
                "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name.to_s.downcase,
                "data-star-count" => rating_max_value, "data-url" => options[:url] do

      "#{link_to_with_icon 'icon-chevron-up icon-medium rate_thumb', "", '#', 'data-value' => '2'} <span class='up'>#{up_votes.to_s}</span> #{link_to_with_icon 'icon-chevron-down icon-medium rate_thumb', "", '#', 'data-value' => '1'} <span class='down'>#{down_votes}</span>".html_safe
    end

  end

  def plus(rateable_obj, options)
    rating_max_value = options['max_value']
    up_votes = rateable_obj.ratings.where("( value / max_value ) > 0.5").count
    down_votes = rateable_obj.ratings.where("( value / max_value ) <= 0.5").count
    avg_rate = number_with_precision rateable_obj.avg_rate, :precision => 2
    content_tag :div, "", :class => "thumbs_container", :id => "#{rateable_obj.class.name.to_s.downcase}_#{rateable_obj.id}", "data-rating" => avg_rate,
                "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name.to_s.downcase,
                "data-star-count" => rating_max_value, "data-url" => options[:url] do

      "#{link_to_with_icon 'icon-plus icon-medium rate_thumb', "", '#', 'data-value' => '2'} <span class='up'>#{up_votes.to_s}</span> #{link_to_with_icon 'icon-minus icon-medium rate_thumb', "", '#', 'data-value' => '1'} <span class='down'>#{down_votes}</span>".html_safe
    end

  end

  def star(rateable_obj, options)
    rating_max_value = options['max_value']
    avg_rate = number_with_precision rateable_obj.avg_rate * rateable_obj.rating_category.max_value, :precision => 2

    content_tag :div, "", :class => "star", :id => "#{rateable_obj.class.name.to_s.downcase}_#{rateable_obj.id}", "data-rating" => avg_rate,
                "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name.to_s.downcase,
                "data-star-count" => rating_max_value, "data-url" => options[:url]

  end

  def comment_form(object, url, method = "POST", display_none = false, parent_id = false)
    render :partial => "shared/comment_form", :formats => :html, :locals => {:object => object,
                                                                             :url => url,
                                                                             :method => method,
                                                                             :parent_id => parent_id,
                                                                             :display_none => display_none}
  end

  # Make an admin tab that coveres one or more resources supplied by symbols
  # Option hash may follow. Valid options are
  #   * :label to override link text, otherwise based on the first resource name (translated)
  #   * :route to override automatically determining the default route
  #   * :match_path as an alternative way to control when the tab is active, /products would match /admin/products, /admin/products/5/variants etc.
  def tab(*args)

    options = {:label => args.first.to_s}
    if args.last.is_a?(Hash)
      options = options.merge(args.pop)
    end
    options[:route] ||= "admin_#{args.first}"

    destination_url = options[:url]

    #titleized_label = t(options[:label], :default => options[:label]).titleize
    titleized_label = options[:label].titleize

    if options[:icon]
      link = link_to("
                   <span class='icon'>
                      <i class='icon-#{options[:icon]}'></i>
                   </span>
                   <span class='text'> #{titleized_label}</span>".html_safe,
                     destination_url)
    else
      link = link_to(titleized_label, destination_url) unless options[:icon]
    end

    css_classes = []

    #logger.info ("request.fullpath=  " + request.fullpath)
    #logger.info ("match_path......=  " + (options[:match_path] ? options[:match_path] : ""))

    selected = if options[:match_path]
                 ## TODO: `request.fullpath` for engines mounted at '/' returns '//'
                 ## which seems an issue with Rails routing.- revisit issue #910
                 #request.fullpath.gsub('//', '/').starts_with?("#{root_path}admin#{options[:match_path]}")
                 request.fullpath.gsub('//', '/').match(options[:match_path]).to_s == request.fullpath
               else
                 args.include?(controller.controller_name.to_sym)
               end
    css_classes << 'active' if selected

    if options[:css_class]
      css_classes << options[:css_class]
    end
    content_tag('li', link, :class => css_classes.join(' '))
  end

  #For perfectum & font-awesome
  def link_to_with_icon(icon_class, text, url, options = {})
    options[:class] = (options[:class].to_s + ' icon_link').strip
    link_to(font_icon(icon_class) + ' ' + text, url, options)
  end


  def link_to_delete(resource, options={})
    url = options[:url] || object_url(resource)
    confirm = options[:confirm] || t(:are_you_sure)
    name = options[:name] || font_icon('icon-trash icon-white') + ' ' + t(:delete)
    link_to name.html_safe, url,
            :class => options[:class],
            :remote => true,
            :method => :delete,
            :data => {:confirm => confirm}

  end

  def font_icon(icon_class)
    icon_class ? "<i class='#{icon_class}'></i>".html_safe : ""
  end

  def current_user
    @current_user || @current_anonymous_user
  end

  def simple_date(date)
    date.strftime('%b %d, %Y')
  end


end