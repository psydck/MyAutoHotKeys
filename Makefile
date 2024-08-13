
# Git
ga: 	# git add ~ make ga files="*"
	@git add $(files)

gc: 	# git commit -m "message" ~ make gc message="*"
	@git commit -m "$(message)"

gcb: 	# git checkout [branch] ~ make ga branch="*"
	@git checkout "$(branch)"

gfom: 	# git fetch origin main ~ make gfom
	@git fetch origin main

gpom: 	# git push origin main ~ make gpom
	@git push origin main

gflm: 	# git fetch local main ~ make gflm
	@git fetch local main

gplm: 	# git push local main ~ make gplm
	@git push local main

grc:	# removes git cached files ~ make grc	
	@git rm -r --cached .

gs: 	# git status ~ make gs
	@git status

gPom:	# add files, commit message and push
	@echo -e "\n\n------------- Status -------------\n\n"
	@git status
	@echo -e "\n\n------------- Staged Files -------------\n\n"
	@git add $(files)
	@git status
	@echo -e "\n\n------------- Commited -------------\n\n"
	@git commit -m "$(message)"
	@echo -e "\n\n------------- Status -------------\n\n"
	@git status
	@echo -e "\n\n------------- Published -------------\n\n"
	@git push origin main
	@echo -e "\n\n------------- Status -------------\n\n"
	@git status
	@echo -e "\n\n------------- Done -------------\n"

gPlm:	# add files, commit message and push
	@echo -e "\n\n------------- Status -------------\n\n"
	@git status
	@echo -e "\n\n------------- Staged Files -------------\n\n"
	@git add $(files)
	@git status
	@echo -e "\n\n------------- Commited -------------\n\n"
	@git commit -m "$(message)"
	@echo -e "\n\n------------- Status -------------\n\n"
	@git status
	@echo -e "\n\n------------- Published -------------\n\n"
	@git push local main
	@echo -e "\n\n------------- Status -------------\n\n"
	@git status
	@echo -e "\n\n------------- Done -------------\n"
