def pause
  $stderr.write "Press enter to continue"
  $stdin.gets
end

def debugit
  page.driver.debug(binding)
end
