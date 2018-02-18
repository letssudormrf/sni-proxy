#!/bin/sh

if [ -n "${USER}" ]; then
echo "user ${USER}" >> /tmp/sniproxy.conf
fi

if [ -n "${GROUP}" ]; then
echo "group ${GROUP}" >> /tmp/sniproxy.conf
fi

if [ -n "${DNS}" ]; then
awk -v rules="${DNS}" 'BEGIN {
    split (rules, sections, " ");
    print "resolver {"
    for (section in sections) {
        split (sections[section], rule, ";")
        print "   " rule[1] " " rule[2]
    }
    print "}\n"
}' >> /tmp/sniproxy.conf
fi

awk -v listeners="${LISTENERS}" 'BEGIN {
    split (listeners, sections, " ");
    for (section in sections) {
        split (sections[section], listener, ";")
        print "listener " listener[2] " {\n   proto " listener[1] "\n   table " listener[1] "\n}\n"
    }
}' >> /tmp/sniproxy.conf

awk -v rules="${RULES_HTTP}" 'BEGIN {
    split (rules, sections, " ");
    print "table http {"
    for (section in sections) {
        split (sections[section], rule, ";")
        print "   " rule[1] " " rule[2]
    }
    print "}\n"
}' >> /tmp/sniproxy.conf

awk -v rules="${RULES_TLS}" 'BEGIN {
    split (rules, sections, " ");
    print "table tls {"
    for (section in sections) {
        split (sections[section], rule, ";")
        print "   " rule[1] " " rule[2]
    }
    print "}\n"
}' >> /tmp/sniproxy.conf

echo "*** Show sniproxy configuration ***"
cat /tmp/sniproxy.conf

echo "*** Startup $0 suceeded now starting service using eval to expand CMD variables ***"
exec su-exec sniproxy $(eval echo "$@")
