class @MilestoneSelect
  constructor: () ->
    $('.js-milestone-select').each (i, dropdown) ->
      $dropdown = $(dropdown)
      projectId = $dropdown.data('project-id')
      milestonesUrl = $dropdown.data('milestones')
      issueUpdateURL = $dropdown.data('issueUpdate')
      selectedMilestone = $dropdown.data('selected')
      showNo = $dropdown.data('show-no')
      showAny = $dropdown.data('show-any')
      useId = $dropdown.data('use-id')
      defaultLabel = $dropdown.data('default-label')
      issuableId = $dropdown.data('issuable-id')

      $dropdown.glDropdown(
        data: (term, callback) ->
          $.ajax(
            url: milestonesUrl
          ).done (data) ->
            if showNo
              data.unshift(
                id: '0'
                title: 'No Milestone'
              )

            if showAny
              data.unshift(
                isAny: true
                title: 'Any Milestone'
              )

            if data.length > 2
              data.splice 2, 0, 'divider'

            callback(data)
        filterable: true
        search:
          fields: ['title']
        selectable: true
        toggleLabel: (selected) ->
          if selected && 'id' of selected
            selected.title
          else
            defaultLabel
        fieldName: $dropdown.data('field-name')
        text: (milestone) ->
          milestone.title
        id: (milestone) ->
          if !useId
            if !milestone.isAny?
              milestone.title
            else
              ''
          else
            milestone.id
        isSelected: (milestone) ->
          milestone.title is selectedMilestone

        clicked: (e) ->
          if $dropdown.hasClass "js-filter-submit"
            $dropdown.parents('form').submit()
          else
            selected = $dropdown
              .closest('.selectbox')
              .find('input[type="hidden"]')
              .val()

            $.ajax(
              type: 'PUT'
              url: issueUpdateURL
              data:
                issue: 
                  milestone_id: selected
            ).done (data) ->
              console.log 'databack', data
      )