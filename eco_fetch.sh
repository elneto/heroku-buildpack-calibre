#!/bin/bash
# This is free and unencumbered shell script released into the public domain.
#

####################### Begin Customization Section #############################
#
# Name of the recipe to fetch. You can run:
#     ebook-convert --list-recipes
# to look for the correct name. Do not forget the .recipe suffix
RECIPE="$HOME/news/economist.recipe"
OUTDIR="$HOME/news/mobi" 

# Select your output profile. See https://manual.calibre-ebook.com/generated/en/ebook-convert.html
# for a list. Common choices: kindle, kindle_dx, kindle_fire, kobo, ipad, sony
OUTPROFILE="kindle_fire"

# A text file with an email per line. This script will send an email to each one.
# You can set it to "" to not send any email
# EMAILSFILE="$HOME/news/emails_eco_list.txt"
EMAILSFILE="$HOME/news/email_test.txt"

# A prefix for the emails' subject. The date will be appended to it.
SUBJECTPREFIX="News: The Economist"
# A prefix for the emails' content. The date will be appended to it.
CONTENTPREFIX="Attached is the your periodical downloaded by calibre"
# A prefix for generate file. The date will be appended to it.
OUTPUTPREFIX="eco_"
#
######################## End Customization Section #############################

DATEFILE=`date "+%Y_%m_%d"`
DATESTR=`date "+%Y/%m/%d"`
OUTFILE="${OUTDIR}/${OUTPUTPREFIX}${DATEFILE}.mobi"

echo "Fetching $RECIPE into $OUTFILE"
ebook-convert "$RECIPE" "$OUTFILE" --output-profile "$OUTPROFILE" 

# Change the author of the ebook from "calibre" to the current date. 
# I do this because sending periodicals to a Kindle Touch is removing
# the periodical format and there is no way to differentiate between
# two editions in the home screen. This way, the date is shown next 
# to the title.
# See http://www.amazon.com/forum/kindle/ref=cm_cd_t_rvt_np?_encoding=UTF8&cdForum=Fx1D7SY3BVSESG&cdPage=1&cdThread=Tx1AP36U78ZHQ1I
# and, please, email amazon (kindle-feedback@amazon.com) asking to add 
# a way to keep the peridiocal format when sending through @free.kindle.com 
# addresses
echo "Setting date $DATESTR as author in $OUTFILE"
ebook-meta -a "$DATESTR" "$OUTFILE"

echo "Sending $OUTFILE to $EMAILSFILE"
BCCLIST=$(cat $EMAILSFILE)

echo "$CONTENTPREFIX ($DATESTR)" | mutt -s "$SUBJECTPREFIX ($DATESTR)" "$BCCLIST" -a "$OUTFILE"

