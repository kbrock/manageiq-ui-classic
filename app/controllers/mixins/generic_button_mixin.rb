module Mixins
  module GenericButtonMixin
    # handle buttons pressed on the button bar

    def handle_vm_buttons(pressed)
      return [:not_started, nil] unless vm_style_button?(pressed)

      pfx = pfx_for_vm_button_pressed(pressed)
      process_vm_buttons(pfx)

      # Control transferred to another screen, so return
      return [:finished, pfx] if vm_button_redirected?(pfx, pressed)

      unless ["#{pfx}_edit", "#{pfx}_miq_request_new", "#{pfx}_clone",
              "#{pfx}_migrate", "#{pfx}_publish", 'vm_rename'].include?(pressed)
        @refresh_div = "main_div"
        @refresh_partial = "layouts/gtl"
        show # Handle VMs buttons
      end
      [:continue, pfx]
    end

    def handle_tag_buttons(pressed)
      case pressed
      when "#{self.class.table_name}_tag"     then tag(self.class.model)
      when 'cloud_network_tag'                then tag(CloudNetwork)
      when 'cloud_object_store_container_tag' then tag(CloudObjectStoreContainer)
      when 'cloud_object_store_object_tag'    then tag(CloudObjectStoreObject)
      when 'cloud_subnet_tag'                 then tag(CloudSubnet)
      when 'cloud_tenant_tag'                 then tag(CloudTenant)
      when 'cloud_volume_snapshot_tag'        then tag(CloudVolumeSnapshot)
      when 'cloud_volume_tag'                 then tag(CloudVolume)
      when 'floating_ip_tag'                  then tag(FloatingIp)
      when 'load_balancer_tag'                then tag(LoadBalancer)
      when 'network_port_tag'                 then tag(NetworkPort)
      when 'network_router_tag'               then tag(NetworkRouter)
      when 'network_service_tag'              then tag(NetworkService)
      when 'network_service_entry_tag'        then tag(NetworkServiceEntry)
      when 'security_group_tag'               then tag(SecurityGroup)
      when 'security_policy_tag'              then tag(SecurityPolicy)
      when 'security_policy_rule_tag'         then tag(SecurityPolicyRule)
      end

      @flash_array.nil? ? :finished : :continue
    end

    def button
      @edit = session[:edit] # Restore @edit for adv search box
      params[:display] = @display if %w[vms images instances].include?(@display)
      params[:page] = @current_page unless @current_page.nil? # Save current page for list refresh

      if params[:pressed] == "custom_button"
        custom_buttons
        return
      end

      handle_status = :not_started
      # Handle vm-style buttons if included in the controller
      if respond_to?(:process_vm_buttons, true)
        handle_status, pfx = handle_vm_buttons(params[:pressed])
        return if handle_status == :finished
      end

      # Handle tag buttons if tagging supported by the controller
      if handle_status == :not_started &&
         respond_to?(:tag, true) && params[:pressed].ends_with?("_tag")

        handle_status = handle_tag_buttons(params[:pressed])
        return if handle_status == :finished
      end

      if handle_status == :not_started &&
         respond_to?(:specific_buttons, true)

        handled = specific_buttons(params[:pressed])
        return if handled
      end

      check_if_button_is_implemented

      if single_delete_test
        single_delete_redirect
        return
      end

      if params[:pressed].ends_with?("_edit") ||
         ["#{pfx}_miq_request_new", "#{pfx}_clone", "#{pfx}_migrate", "#{pfx}_publish"].include?(params[:pressed]) ||
         params[:pressed] == 'vm_rename' && @flash_array.nil?
        render_or_redirect_partial(pfx)
      elsif @refresh_div == "main_div" && @lastaction == "show_list"
        replace_gtl_main_div
      else
        render_flash unless performed?
      end
    end

    def evaluate_button(action, allowed_actions)
      unless allowed_actions.key?(action)
        raise ActionController::RoutingError, _('Invalid button action')
      end

      send_action = allowed_actions[action]
      send(send_action)
    end

    def validate_item_supports_action_button(action, item_type)
      unless checked_item_id
        error_msg = (_("\"%{action}\" requires a single item to be selected.") % {
          :action => action
        })
        return {:action_supported => false, :message => error_msg}
      end

      item = find_record_with_rbac(item_type, checked_item_id)
      return {:action_supported => true, :message => nil} if item.supports?(action)

      error_msg = (_("\"%{item_name}\" does not supports %{action}") % {
        :item_name => item.name,
        :action    => action
      })
      {:action_supported => false, :message => error_msg}
    end
  end
end
