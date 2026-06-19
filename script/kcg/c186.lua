--ダークネス
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_CANNOT_INACTIVATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--Cannot look
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetCode(EFFECT_DARKNESS_HIDE)
	e2:SetTarget(function(e,c) return c:IsFacedown() and c:GetFlagEffect(id)>0 end)
	c:RegisterEffect(e2)
	
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(1,0)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetValue(s.noact)
	c:RegisterEffect(e6)

	--reset
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(s.activate2)
	c:RegisterEffect(e3)

	--Destroy2
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(s.descon2)
	e4:SetOperation(s.desop2)
	c:RegisterEffect(e4)

	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(LOCATION_SZONE,0)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetTarget(s.eest)
	e8:SetValue(s.eefilter)
	c:RegisterEffect(e8)
end
s.listed_series={0x316}

function s.filter(c,code)
	return c:IsCode(code) and c:IsSSetable()
end
function s.filter22(c,code)
	return c:IsCode(code) and c:IsFaceup() and not c:IsStaus(STATUS_DISABLED)
end
function s.defilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) 
end
function s.tffilter(c)
	return c:IsSSetable() and c:ListsArchetype(0x316) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function s.ctcheck(sg,e,tp)
	return sg:GetClassCount(Card.GetCode)==#sg
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<5 then return end
	local sg=Duel.GetMatchingGroup(s.tffilter,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE,0,1,nil)
	if sg:GetClassCount(Card.GetCode)<4 then return end
	Duel.BreakEffect()
	local setg=aux.SelectUnselectGroup(sg,e,tp,5,5,s.ctcheck,1,tp,HINTMSG_SET)
	if #setg>0 then
		setg:ForEach(function(c) 
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_TURN_SET,0,1)
		end)
		Duel.SSet(tp,setg)
		Duel.ShuffleSetCard(setg)
	end
end

function s.noact(e,re,tp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) 
	and bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)~=0
	and Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,e:GetHandler())
	and rc:GetFlagEffect(188)==0
end

function s.filterset(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.filterset,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN)
		Duel.RaiseEvent(g,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		Duel.ShuffleSetCard(Duel.GetFieldGroup(tp,LOCATION_SZONE,0):Filter(function(c) return c:GetSequence()<5 end,e:GetHandler()))
		g:ForEach(function(c) 
			c:SetStatus(STATUS_SET_TURN,true)
		end)
	end 
end

function s.leavefilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_SPELL+TYPE_TRAP)
	and c:GetPreviousControler()==tp 
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.leavefilter,1,nil,e,tp) 
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.defilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

function s.eest(e,c)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function s.eefilter(e,te)
	return not te:GetOwner():ListsArchetype(0x316)
end
