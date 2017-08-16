# -*- coding: utf-8 -*-

from __future__ import print_function
import httplib2
import os, sys
import time
from apiclient import discovery
from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage
from pydrive.auth import GoogleAuth

from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive

#from gist  https://gist.github.com/macieksk/038b201a54d9e804d1b5

#TODO : add Tkinter gui to select folder and files that we want to backup
#TODO :	pull a certain "version" or a certain backup

def login():
    global gauth, drive
    gauth = GoogleAuth()
    gauth.LocalWebserverAuth() # Creates local webserver and auto handles authentication
    drive = GoogleDrive(gauth) # Create GoogleDrive instance with authenticated GoogleAuth instance

def root_files():
    file_list = drive.ListFile({'q': "'root' in parents and trashed=false"}).GetList()
    # Auto-iterate through all files in the root folder.
    #for file1 in file_list:
    #    print 'title: %s, id: %s' % (file1['title'], file1['id'])
    return file_list


def find_folders(fldname):
    file_list = drive.ListFile({
        'q': "title='{}' and mimeType contains 'application/vnd.google-apps.folder' and trashed=false".format(fldname)
        }).GetList()
    return file_list


def create_subfolder(folder,sfldname):
    new_folder = drive.CreateFile({'title':'{}'.format(sfldname),
                               'mimeType':'application/vnd.google-apps.folder'})
    if folder is not None:
        new_folder['parents'] = [{u'id': folder['id']}]
    new_folder.Upload()
    return new_folder


def list_files_with_ext(ext,dir='./'):
    return sorted(filter(lambda f:f[-len(ext):]==ext,os.listdir(dir)))


def upload_files_to_folder(fnames, folder):
    #file1 = drive.CreateFile({'title': 'Hello.txt'}) # Create GoogleDriveFile instance with title 'Hello.txt'
    #file1.Upload() # Upload it
    #print 'title: %s, id: %s' % (file1['title'], file1['id']) # title: Hello.txt, id: {{FILE_ID}}

    for fname in fnames:
        nfile = drive.CreateFile({'title':os.path.basename(fname),
                                  'parents':[{u'id': folder['id']}]})
        nfile.SetContentFile(fname)
        nfile.Upload()

def push_new_backup_folder():
	#folder = find_folders('test')[0]
	#t = time.gmtime()
	#tt= str(t.tm_year)+"-"+str(t.tm_mon)+"-"+str(t.tm_mday)+"_"+ str(t.tm_hour)\
	#		+"-"+ str(t.tm_min)
	new_folder = create_subfolder(None,'back_up')
	list_of_sorted_files  = list_files_with_ext('.tar.gz', dir='./')
	print ("files to updates:"+str(list_of_sorted_files))
	upload_files_to_folder(list_files_with_ext('.tar.gz')[:3],new_folder)
	return new_folder

def pull_backup():
	back_up = find_folders("back_up")
	print (back_up)
	file_list = drive.ListFile({'q': "'root' in parents and trashed=false"}).GetList()
	for file1 in file_list:
		print("title:{}, id: {}".format(file1['title'], file1['id'])

def main():
	if len(sys.argv) < 2 :
		print ("usage: python drive.py --push_backup file.tar.gz")
		print ("usage: python drive.py --pull_backup")
		exit()
	print (sys.argv[1])
	login()
	if sys.argv[1] == "--push_backup":
		push_new_backup_folder()
	if sys.argv[1] == "--pull_backup":
		pull_backup()


if __name__ == "__main__":
	main()
	
