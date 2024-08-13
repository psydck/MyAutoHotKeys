
# Git
ga: 	# git add <files> ~ make ga files="*"
	@echo -e "\n------------- \033[1;35m Staged \033[0m -------------\n"
	@git add $(files)
	@git status

gc: 	# git commit -m "message" ~ make gc message="*"
	@echo -e "\n------------- \033[0;32m Commited \033[0m -------------\n"
	@git commit -m "$(message)"

gcb: 	# git checkout <branch> ~ make gcb branch="*"
	@echo -e "\n------------- \033[1;36m Switching to [$(branch)] Branch \033[0m -------------\n"
	@git checkout $(branch)

gfom: 	# [fetch from remote main repo] -> git fetch origin main ~ make gfom
	@echo -e "\n------------- \033[1;36m Fetched files on [origin/main] \033[0m -------------\n"
	@git fetch origin main

gpom: 	# [push to remote main repo] -> git push origin main ~ make gpom
	@echo -e "\n-------------  \033[1;32m Published \033[0m -------------\n"
	@git push origin main

gflm: 	# [fetch from local main repo] -> git fetch local main ~ make gflm
	@echo -e "\n------------- \033[1;36m Fetched files on [local/main] \033[0m -------------\n"
	@git fetch local main

gplm: 	# [push to local main repo] -> git push local main ~ make gplm
	@echo -e "\n-------------  \033[1;32m Published \033[0m -------------\n"
	@git push local main

gr:		# [restore changes made on file(s)] -> git restore <files> ~ make gr files="*"
	@echo -e "\n------------- \033[0;31m Restore changes made on files \033[0m -------------\n"
	@git restore $(files)

grs:	# [unstage file(s)] -> git restore <files> ~ make grs files="*" 
	@echo -e "\n------------- \033[0;35m Unstaged \033[0m -------------\n"
	@git restore --staged $(files)

grc:	# [remove tracked files] -> git cached files ~ make grc	
	@echo -e "\n------------- \033[0;31m Removed tracked files \033[0m -------------\n"
	@git rm -r --cached .

gs: 	# git status ~ make gs
	@echo -e "\n------------- \033[1;33m Status \033[0m -------------\n"
	@git status

gPom:	# add files, commit message and push
	@echo -e "\n------------- \033[1;33m Status \033[0m -------------\n"
	@git status
	@echo -e "\n------------- \033[1;35m Staged \033[0m -------------\n"
	@git add $(files)
	@git status
	@echo -e "\n------------- \033[0;32m Commited \033[0m -------------\n"
	@git commit -m "$(message)"
	@echo -e "\n-------------  \033[1;33m Status \033[0m -------------\n"
	@git status
	@echo -e "\n-------------  \033[1;32m Published \033[0m -------------\n"
	@git push origin main
	@echo -e "\n------------- \033[1;33m Status \033[0m -------------\n"
	@git status
	
gPlm:	# add files, commit message and push
	@echo -e "\n------------- \033[1;33m Status \033[0m -------------\n"
	@git status
	@echo -e "\n------------- \033[1;35m Staged \033[0m -------------\n"
	@git add $(files)
	@git status
	@echo -e "\n------------- \033[0;32m Commited \033[0m -------------\n"
	@git commit -m "$(message)"
	@echo -e "\n-------------  \033[1;33m Status \033[0m -------------\n"
	@git status
	@echo -e "\n-------------  \033[1;32m Published \033[0m -------------\n"
	@git push local main
	@echo -e "\n------------- \033[1;33m Status \033[0m -------------\n"
	@git status
