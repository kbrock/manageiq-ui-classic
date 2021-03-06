class ApplicationHelper::Toolbar::MiqScheduleCenter < ApplicationHelper::Toolbar::Basic
  button_group('miq_schedule_vmdb', [
    select(
      :miq_schedule_vmdb_choice,
      nil,
      t = N_('Configuration'),
      t,
      :items => [
        button(
          :schedule_edit,
          'pficon pficon-edit fa-lg',
          t = N_('Edit this Schedule'),
          t),
        button(
          :schedule_delete,
          'pficon pficon-delete fa-lg',
          t = N_('Delete this Schedule from the Database'),
          t,
          :url_parms => "&refresh=y",
          :confirm   => N_("Warning: This Schedule and ALL of its components will be permanently removed!")),
        button(
          :schedule_enable,
          'fa fa-check fa-lg',
          t = N_('Enable this Schedule'),
          t
        ),
        button(
          :schedule_disable,
          'fa fa-ban fa-lg',
          t = N_('Disable this Schedule'),
          t
        ),
        separator,
        button(
          :schedule_run_now,
          'fa fa-play-circle-o fa-lg',
          t = N_('Queue up this Schedule to run now'),
          t,
          :klass => ApplicationHelper::Button::ScheduleRunNow),
      ]
    ),
  ])
end
