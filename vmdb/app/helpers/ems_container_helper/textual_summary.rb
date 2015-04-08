module EmsContainerHelper::TextualSummary
  #
  # Groups
  #

  def textual_group_properties
    items = %w(name type hostname ipaddress port zone)
    items.collect { |m| send("textual_#{m}") }.flatten.compact
  end

  def textual_group_relationships
    items = %w(container_nodes container_services container_groups)
    items.collect { |m| send("textual_#{m}") }.flatten.compact
  end

  def textual_group_status
    items = %w(refresh_status)
    items.collect { |m| send("textual_#{m}") }.flatten.compact
  end

  #
  # Items
  #

  def textual_name
    {:label => "Name", :value => @ems.name}
  end

  def textual_type
    {:label => "Type", :value => @ems.emstype_description}
  end

  def textual_hostname
    {:label => "Hostname", :value => @ems.hostname}
  end

  def textual_ipaddress
    {:label => "IP Address", :value => @ems.ipaddress}
  end

  def textual_port
    @ems.supports_port? ? {:label => "Port", :value => @ems.port} : nil
  end

  def textual_zone
    {:label => "Managed by Zone", :image => "zone", :value => @ems.zone.name}
  end

  def textual_refresh_status
    last_refresh_status = @ems.last_refresh_status.titleize
    if @ems.last_refresh_date
      last_refresh_date = time_ago_in_words(@ems.last_refresh_date.in_time_zone(Time.zone)).titleize
      last_refresh_status << " - #{last_refresh_date} Ago"
    end
    {
      :label => "Last Refresh",
      :value => [{:value => last_refresh_status},
                 {:value => @ems.last_refresh_error.try(:truncate, 120)}],
      :title => @ems.last_refresh_error
    }
  end

  def textual_container_nodes
    count_of_nodes = @ems.number_of(:container_nodes)
    label = "Container Nodes"
    h     = {:label => label, :image => "container_node", :value => count_of_nodes}
    if count_of_nodes > 0 && role_allows(:feature => "container_node_show_list")
      h[:link]  = url_for(:action => 'show', :id => @ems, :display => 'container_nodes')
      h[:title] = "Show all #{label}"
    end
    h
  end

  def textual_container_services
    count_of_services = @ems.number_of(:container_services)
    label = "Container Services"
    h     = {:label => label, :image => "container_service", :value => count_of_services}
    if count_of_services > 0 && role_allows(:feature => "container_service_show_list")
      h[:link]  = url_for(:action => 'show', :id => @ems, :display => 'container_services')
      h[:title] = "Show all #{label}"
    end
    h
  end

  def textual_container_groups
    count_of_groups = @ems.number_of(:container_groups)
    label = "Container Groups"
    h     = {:label => label, :image => "container_group", :value => count_of_groups}
    if count_of_groups > 0 && role_allows(:feature => "container_group_show_list")
      h[:link]  = url_for(:action => 'show', :id => @ems, :display => 'container_groups')
      h[:title] = "Show all #{label}"
    end
    h
  end
end

