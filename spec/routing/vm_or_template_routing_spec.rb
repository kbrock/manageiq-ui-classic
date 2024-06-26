require "routing/shared_examples"

describe VmOrTemplateController do
  let(:controller_name) { "vm_or_template" }

  it_behaves_like "A controller that has advanced search routes"
  it_behaves_like "A controller that has compare routes"
  it_behaves_like "A controller that has dialog runner routes"
  it_behaves_like "A controller that has download_data routes"
  it_behaves_like "A controller that has policy protect routes"
  it_behaves_like "A controller that has tagging routes"
  it_behaves_like "A controller that has timeline routes"

  describe "#explorer" do
    it "routes with GET" do
      expect(get("/vm_or_template/explorer")).to route_to("vm_or_template#explorer")
    end

    it "rotues with POST" do
      expect(post("/vm_or_template/explorer")).to route_to("vm_or_template#explorer")
    end
  end

  describe "#show" do
    it "routes with GET" do
      expect(get("/vm_or_template/show")).to route_to("vm_or_template#show")
    end

    it "rotues with POST" do
      expect(post("/vm_or_template/show")).to route_to("vm_or_template#show")
    end
  end

  %w(
    drift_to_csv
    drift_to_pdf
    drift_to_txt
    launch_html5_console
    launch_vmrc_console
    vm_show
  ).each do |path|
    describe "##{path}" do
      it "routes with GET" do
        expect(get("/vm_or_template/#{path}")).to route_to("vm_or_template##{path}")
      end
    end
  end

  %w(
    accordion_select
    advanced_settings
    button
    dialog_field_changed
    dialog_form_button_pressed
    drift_all
    drift_differences
    drift_history
    drift_mode
    drift_same
    event_logs
    filesystem_drivers
    filesystems
    groups
    guest_applications
    kernel_drivers
    linux_initprocesses
    ownership_update
    patches
    perf_chart_chooser
    policies
    policy_options
    policy_show_options
    policy_sim
    policy_sim_add
    policy_sim_remove
    pre_prov
    pre_prov_continue
    processes
    prov_edit
    prov_field_changed
    reconfigure_update
    registry_items
    reload
    scan_histories
    sections_field_changed
    snap_pressed
    sort_ds_grid
    sort_host_grid
    sort_iso_img_grid
    tree_select
    users
    vm_pre_prov
    vmrc_console
    html5_console
    wait_for_task
    win32_services
    x_button
    x_history
    x_search_by_name
    x_show
  ).each do |path|
    describe "##{path}" do
      it "routes with POST" do
        expect(post("/vm_or_template/#{path}")).to route_to("vm_or_template##{path}")
      end
    end
  end
end
