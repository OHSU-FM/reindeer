a = User.create!(username: 'admin', email: 'admin@test.com', password: 'password', is_admin: true)
s = User.create!(username: 'student', email: 'student@test.com', password: 'password')
pg = PermissionGroup.create!(title: 'test pg')
cohort = Cohort.create!(owner: c, users: [s], permission_group: pg)
ct = CommentThread.create!(commentable: cohort, user: s)
