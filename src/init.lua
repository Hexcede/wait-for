--!strict
local Package = script
local Packages = Package.Parent
local Promise = require(Packages.Promise)

local WaitFor = {}

type Waitable<R...> = {
	Wait: (waitable: Waitable<R...>) -> (R...);
}

function WaitFor._waitFor<T..., R...>(target: Instance, event: Waitable<R...>, findInstance: (target: Instance, T...) -> Instance?, ...: T...)
	return Promise.try(function(...)
		local instance

		repeat
			instance = findInstance(target, ...)

			if not instance then
				event:Wait()
			end
		until instance

		return instance
	end, ...)
end

function WaitFor.ChildByName(parent: Instance, childName: string)
	return WaitFor._waitFor(parent, parent.ChildAdded, parent.FindFirstChild, childName)
end

function WaitFor.ChildWhichIsA(parent: Instance, className: string)
	return WaitFor._waitFor(parent, parent.ChildAdded, parent.FindFirstChildWhichIsA, className)
end

function WaitFor.ChildOfClass(parent: Instance, className: string)
	return WaitFor._waitFor(parent, parent.ChildAdded, parent.FindFirstChildOfClass, className)
end

return WaitFor