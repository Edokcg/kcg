--ダークネス
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
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
	e2:SetTarget(function(e,c) return c:GetFlagEffect(id)~=0 and c:IsFacedown() end)
	c:RegisterEffect(e2)
	
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(1,0)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetValue(s.noact)
	c:RegisterEffect(e6)

	--RandomOpen
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	-- e2:SetDescription(aux.Stringid(100000590,0))
	-- e2:SetType(EFFECT_TYPE_QUICK_O)
	-- e2:SetCode(EVENT_FREE_CHAIN)
	-- e2:SetCountLimit(1)
	-- e2:SetRange(LOCATION_FZONE)
	-- e2:SetHintTiming(0,0x1e0)
	-- e2:SetLabelObject(e1)
	-- e2:SetCondition(s.condition)
	-- e2:SetOperation(s.operation)
	-- c:RegisterEffect(e2)

	--reset
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.target2)
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
s.listed_names={511310101,511310102,511310103,511310104,511310105}
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
	return c:IsSSetable() 
	and c:IsCode(511310101,511310102,511310103,511310104,511310105) and c:IsSSetable()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(Duel.GetTurnCount())
	local g=Duel.GetMatchingGroup(s.defilter,tp,LOCATION_ONFIELD,0,c)
	if g:GetCount()~=0 then Duel.Destroy(g,REASON_EFFECT) Duel.BreakEffect() end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<5 then return end
	if ft>5 then ft=5 end
	--darkness
	if Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,511310101)==0 then return end 
	if Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,511310102)==0 then return end 
	if Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,511310103)==0 then return end 
	if Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,511310104)==0 then return end 
	if Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,511310105)==0 then return end 
	local sg=Duel.GetMatchingGroup(s.tffilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g1=sg:Select(tp,1,1,nil)
	sg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	ft=ft-1
	local g2=Group.CreateGroup()
	while ft>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		g2=sg:Select(tp,1,1,nil)
		g1:Merge(g2)
		sg:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		ft=ft-1
	end
	Duel.SSet(tp,g1,tp,false)
	Duel.ShuffleSetCard(g1)
	local sg=Duel.GetOperatedGroup()
	while sg:GetCount()>0 do
		local tc=sg:GetFirst()
		sg:RemoveCard(tc)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
	end
end

function s.noact(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)~=0
	and Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,e:GetHandler())
end
function s.filterset(c)
	return c:IsType(TYPE_TRAP) and c:IsFaceup()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filterset,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.filterset,tp,LOCATION_ONFIELD,0,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN)
		Duel.RaiseEvent(g,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		Duel.ShuffleSetCard(Duel.GetFieldGroup(tp,LOCATION_SZONE,0):Filter(function(c) return c:GetSequence()<5 end,nil))
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
	return not te:GetOwner():IsSetCard(0x316)
	  and not te:GetOwner():IsCode(511310104,511310105)
end
