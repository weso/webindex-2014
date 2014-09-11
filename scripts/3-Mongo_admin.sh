mongodb_user=wix_admin
mongodb_pass=root

# Create Mongo admin user
echo "db.createUser({user: \"$mongodb_user\", pwd: \"$mongodb_pass\", roles: [{ role: \"userAdminAnyDatabase\", db: \"admin\"}]})" > admin_user.js

mongo localhost:27017/admin admin_user.js

rm -rf admin_user.js
