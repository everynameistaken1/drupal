file="/var/www/html/$PROJECT_NAME/web/sites/default/settings.php"
t=$(mktemp)
IGNORECASE=0
awk '{
  if ( $0 ~ /^\$databases\[/ )
    { print "if \(\$_SERVER\[\"HTTP_USER_AGENT\"\] !== \"Drupal command line\"\) \{ \n " $0 }
  else
    { print }
}
END {
  print "\n\}\n"
}' $file > $t && mv $t $file
