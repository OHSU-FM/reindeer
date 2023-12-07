
#Rails.application.config.assets.paths << Rails.root.join("node_modules")
#
# Rails.application.config.assets.paths += [
#   Rails.root.join('vendor', 'assets').to_s
# ]
#
# # # Precompile additional assets.
# # # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += [
#   Rails.root.join('vendor/assets/javascripts/*').to_s,
#   Rails.root.join('vendor/assets/stylesheets/*').to_s
# ]

Rails.application.config.assets.precompile += %w( print.css
    comments.css
    form-utils.js
    sync_triggers.js
    high_voltage_pages.css
    errors.css errors.js
    sessions.css  sessions.js
    ls_reports_graph.css     ls_reports_graph.js
    stats.css     stats.js
    lime_groups.css lime_groups.js
    ls_files.css ls_files.js
    ls_reports.css ls_reports.js
    ls_reports_filter.css ls_reports_filter.css
    reports.css   reports.js
    charts.css    charts.js
    Chart.bundle.js
    dashboard.css dashboard.js
    ls_reports_spreadsheet.css
    devise_sessions.css
    users.css users.js
    settings_sync_triggers.css
    settings.css
    rails_admin_iframe.css
    dataTables/*
    goals.css
    action_plan_items.css
    rooms.css
    coaching_students.css
    coaching.css
    cable.js
    searches.css
    artifacts.css
    epa_graphs.js
    epa_masters.css
    epa_reviews.css
    epa_master.js
    epa_reviews.js
    wba_graphs.css
    cds_reports.css
    wba_graphs.css
    csl_feedbacks.css
    competencies.css
    courses.css
    epa_masters.css
    epa_reviews.css
    fom_exams.css
    preceptor_evals.css
    student_assessments.css
    events.css
    advisors.css
    jquery.contextmenu/dist/jquery.contextMenu.css
    jquery.contextmenu/dist/jquery.contextMenu.js
    bootstrap.min.js
    popper.js
    fix_eg_members.css
    usmle_exams.css
    epas.css
    epas.js
   )
