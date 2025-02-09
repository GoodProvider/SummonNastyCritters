P_SCRIPTS=p_scripts
DOWN_SCRIPT=p_scripts/creatures_download.py
BUILD_SCRIPT=p_scripts/creatures_build.py
GROUPS_FILE=SummonNastyCritters/data/groups.yaml
CREATURES_FLAT_FILE=SummonNastyCritters/data/creatures_flat.json
CREATURES_FILE=SummonNastyCritters/data/creatures.json
UNSEXABLE_FILE=SummonNastyCritters/data/unsexable.yaml

VERSION=1.0.0
RELEASE_FILE=SummonNastyCritters ${VERSION}.zip

build: ${BUILD_SCRIPT} ${GROUPS_FILE} ${CREATURES_FLAT_FILE} ${UNSEXABLE_FILE}
	 python3 ${BUILD_SCRIPT} -g ${GROUPS_FILE} -c ${CREATURES_FLAT_FILE} -u ${UNSEXABLE_FILE} ${CREATURES_FILE}

release:
	python3 .\p_scripts\copy.py -v ${VERSION} -o 'fomod\info.xml' 'fomod-source\info.xml'
	if exist '${RELEASE_file}' rm /Q /S '${RELEASE_FILE}'
	7z a '${RELEASE_FILE}' fomod Scripts SummonNastyCritters\data\creatures.json SummonNastyCritters.esp


#download: htmls ${DOWN_SCRIPT}
#	 python3 ${DOWN_SCRIPT} -g ${GROUPS_YAML_FILE} -c ${CREATURES_YAML_FILE}
#
#	python3 .\p_scripts\fomod_index.py -v ${VERSION} .\Fomod\info.xml > ${RELEASE_DIR}/

#download: htmls ${DOWN_SCRIPT}
#	 python3 ${DOWN_SCRIPT} -g ${GROUPS_YAML_FILE} -c ${CREATURES_YAML_FILE}
#
#htmls:
#	mkdir htmls
