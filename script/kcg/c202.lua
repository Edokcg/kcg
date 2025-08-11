--Cursed Twin Dolls
function c202.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2196767,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c202.cointg)
	e1:SetOperation(c202.actoperation)
	c:RegisterEffect(e1)

	--discard deck
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(511000120,0))
	--e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	--e3:SetCategory(CATEGORY_DECKDES)
	--e3:SetCode(EVENT_TO_GRAVE)
	--e3:SetRange(LOCATION_SZONE)
	--e3:SetCondition(c202.damcon)
	--e3:SetTarget(c202.damtg)
	--e3:SetOperation(c202.damop)
	--c:RegisterEffect(e3)  
end
c202.opt=0

function c202.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c202.actoperation(e,tp,eg,ep,ev,re,r,rp)
	local rs=0
	local opt=Duel.SelectOption(1-tp,60,61)
	if opt==Duel.TossCoin(tp,1) then res=2 
	else res=1 end

	if res==1 then
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	else
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT) end

	--Recover
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(res)
	e2:SetOperation(c202.operation)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e2)

	--grave redirect
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(LOCATION_REMOVED)
	e3:SetLabel(res)
	e3:SetTarget(c202.rmtg)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e3)
end 

function c202.filter1(c,tp)
	return c:GetOwner()==tp
end
function c202.operation(e,tp,eg,ep,ev,re,r,rp)
	  local d1=0
	  local res=e:GetLabel()
	  if res==1 then d1=eg:FilterCount(c202.filter1,nil,1-tp)*200
						  Duel.Recover(1-tp,d1,REASON_EFFECT) end
	  if res==2 then d1=eg:FilterCount(c202.filter1,nil,tp)*200
						Duel.Recover(tp,d1,REASON_EFFECT) end
end

function c202.rmtg(e,c)
	  local res=e:GetLabel()
	  if res==1 then return c:GetOwner()==e:GetHandlerPlayer() end
	  if res==2 then return c:GetOwner()~=e:GetHandlerPlayer() end
end

function c202.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:GetPreviousControler()==tp
end
function c202.damcon(e,tp,eg,ep,ev,re,r,rp)
	return re and bit.band(r,REASON_EFFECT)~=0 and eg:IsExists(c202.cfilter,1,nil,1-tp) and re:GetHandler():GetCode()~=511000120
end
function c202.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_GRAVE,1,nil,TYPE_MONSTER) end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)*1
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,dam)
end
function c202.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)*1
	Duel.DiscardDeck(1-tp,dam,REASON_EFFECT)
end
