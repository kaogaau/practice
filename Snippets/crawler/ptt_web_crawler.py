import bs4
import urllib2
import re
import time
import logging
import json
import os, sys
import pymongo

 
#connection = pymongo.Connection('220.132.97.119', 37017)
connection = pymongo.Connection('localhost', 27017)
#connect the mongodb
#db = connection.les_enphants
db = connection.fb_crawler
#db.authenticate('phadmin','pw1874')  
db.authenticate('tachen','iscae100')  
table1=db.PTT_BabyMother
#table1.insert(
#			{'partno':'max-001',
#			'name':'jack','age':20}
#			) 
#connect the PTT_BabyMother database

post_url = lambda id: 'http://www.ptt.cc/bbs/BabyMother/' + str(id) + '.html'
page_url = lambda n:  'http://www.ptt.cc/bbs/BabyMother/index' + str(n) + '.html'
num_pushes = dict()
elapsed_time = time.time() 
print("Hello World %s"% elapsed_time)
 
#start page and end page	
startIndex=118
endIndex=2404
for indexP in xrange(startIndex, endIndex):
	try:
		page = bs4.BeautifulSoup(urllib2.urlopen(page_url(indexP)).read())
		print('CCC_indexpost')
	except:
		print('read error')
		continue

	for link in page.find_all(class_='r-ent'):
		try:
			response_str='['
			post_id = link.a.get('href').split('/')[-1][:-5]
			post = bs4.BeautifulSoup(urllib2.urlopen(post_url(post_id)).read())
			#print(post)
			p = re.compile(r'<.*?>')
			
			#print('FFF:'+  p.sub('', str(post.find(id='main-container')))  )
			#print('Title:' + post.title.string.encode('utf-8') + '\n' + '\n' ) 
		except:
			print('read error')
			continue
		int_index=0
		post_author=''
		post_title=''
		post_time=''
		for ccc_test11 in post.find_all(class_='article-metaline'):
			try:
				int_index=int_index+1
				temp_tag_str=( ccc_test11.find(class_='article-meta-tag')  ).get_text()
				temp_tag_value=( ccc_test11.find(class_='article-meta-value')  ).get_text()
				if int_index==1:
					post_author=temp_tag_value
				if int_index==2:
					post_title=temp_tag_value
				if int_index==3:
					post_time=temp_tag_value
			except:
				print('read error')

		#get all comments for this post
		for ccc_test in post.find_all(class_='f3 push-content'):
			try:	
				temp_OO_string= ccc_test.get_text()
				temp_OO_string_length=len(temp_OO_string)
				 
				#print('Oo--oO:'+temp_OO_string[1:temp_OO_string_length])
				response_str=response_str+',\''+  temp_OO_string[1:temp_OO_string_length]   +'\''
				
			except:
				print('read error')
		try:
			#print('CCC_insert')
			response_str=response_str+']'
			#print('CCC_insert'+response_str)
			post = {'main_article': p.sub('', str(post.find(id='main-container'))) ,'responses': response_str,
			'post_author':post_author,
			'post_title':post_title,
			'post_time':post_time
			}
			table1.insert(post)
		except:
			print('read error')
             
		
			#print('error____ppp')
		
			