RG ?= rg-dns-zones
ZONE ?= direct2client.com.au
BICEP ?= dns-direct2client.bicep
PARAMS ?= dns-direct2client.parameters.json

.PHONY: what-if deploy ns verify
what-if:
	az deployment group what-if -g $(RG) -f $(BICEP) -p @$(PARAMS)

deploy:
	az deployment group create -g $(RG) -f $(BICEP) -p @$(PARAMS)

ns:
	az network dns zone show -g $(RG) -n $(ZONE) --query nameServers -o tsv

verify:
	@NS=`az network dns zone show -g $(RG) -n $(ZONE) --query nameServers[0] -o tsv`; \
	echo "Testing against $$NS"; \
	command -v dig >/dev/null 2>&1 && { \
	  dig @$$NS $(ZONE) MX +short || true; \
	  dig @$$NS www.$(ZONE) CNAME +short || true; \
	  dig @$$NS $(ZONE) TXT +short || true; \
	}
