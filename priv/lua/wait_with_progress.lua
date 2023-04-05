return function(milliseconds, params)
  if not params then params = {} end
  local seconds = milliseconds / 1000
  local job = params.job or "Waiting " .. seconds .. "s"
  local status = params.status or "Waiting"
  local start_time = os.time() * 1000

  if milliseconds < 1000 then
    set_job_progress(job, {
      percent = 0,
      status = status,
      time = start_time,
    })
    wait(milliseconds)
  else
    for i = 1, seconds do
      set_job_progress(job, {
        percent = math.floor((i - 1) / seconds * 100),
        status = status,
        time = start_time,
      })
      wait(1000)
    end
    wait(milliseconds % 1000)
  end

  set_job_progress(job, {
    percent = 100,
    status = "Complete",
    time = start_time,
  })
end
