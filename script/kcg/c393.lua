--時械聖域(KDIY)
local s,id=GetID()
function s.initial_effect(c)
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.spcondition)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetValue(s.effectfilter)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id, 0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_FZONE)
	--e5:SetCondition(s.condition2)
	e5:SetTarget(s.target4)
	e5:SetOperation(s.operation2)
	c:RegisterEffect(e5)
	
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_ONFIELD,0)
	e6:SetTarget(aux.OR(aux.TargetBoolFunction(Card.ListsArchetype,SET_TIMELORD),aux.OR(aux.TargetBoolFunction(Card.IsSetCard,SET_TIMELORD))))
	e6:SetValue(1)
	c:RegisterEffect(e6)

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e7)
end
s.listed_series = {SET_TIMELORD}
s.listed_names = {9409625}

function s.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:IsActiveType(TYPE_TRAP) and bit.band(te:GetActivateLocation(),LOCATION_HAND)~=0
end

function s.condition2(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsTurnPlayer(tp)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.filter2(c)
	return ((c:IsSetCard(SET_TIMELORD) and c:IsMonster()) or c:ListsArchetype(SET_TIMELORD)) and c:IsAbleToHand()
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
	end
end

function s.spcondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,SET_TIMELORD)
end
function s.tfilter(c)
	return c:IsSetCard(SET_TIMELORD) and c:IsMonster() and c:IsFaceup()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=eg:Filter(Card.IsSetCard,nil,SET_TIMELORD)
	for tc in aux.Next(sg) do
		local tec={tc:GetTriggerEffect()}
		for _, te in ipairs(tec) do
			local resetflag,resetcount=te:GetReset()
			local selfeffect=te:GetHandler()==te:GetOwner() and resetflag==0 and resetcount==0
			if bit.band(te:GetType(),EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)~=0 and te:GetCode()==EVENT_BATTLED and selfeffect then
				local g=Duel.GetMatchingGroup(s.tfilter,tp,LOCATION_MZONE,0,tc)
				g:Merge(sg)
				g:RemoveCard(tc)
				for tc2 in aux.Next(g) do
					local te2=te:Clone()
					te2:SetDescription(aux.Stringid(tc:GetOriginalCode(), 3))
					te2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
					te2:SetOwner(c)
					te2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
					tc2:RegisterEffect(te2)
				end
			end
		end
	end
end