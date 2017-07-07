EXTENSION = jx_io
DATA = jx_io--0.1.1.sql
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

