#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
from builder_common import BuilderCommon


class BuilderDeploy(BuilderCommon):
  """
  Get packages and send them to the distibution server.\n
  Check indexing packages by version and version update.
  """

  def __init__(self, project_root_path: str):
    super().__init__(project_root_path)
