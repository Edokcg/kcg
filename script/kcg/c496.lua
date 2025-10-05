--神縛りの塚
--Mound of the Bound Creator
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--Cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	-- local e3=e2:Clone()
	-- e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	-- c:RegisterEffect(e3)

	--Damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.damcon)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)

	--Search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(s.thcon)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)

	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetCode(EFFECT_BECOME_QUICK)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(0x3f,0)
	e6:SetCondition(s.qucon)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL))
	c:RegisterEffect(e6)

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_EXTRA_RELEASE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetCondition(s.qucon2)
	c:RegisterEffect(e7)
end
s.listed_names={10000020,10000000,10000000}

function s.target(e,c)
	return c:IsLevelAbove(10)
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	local rc=des:GetReasonCard()
	return des:IsLocation(LOCATION_GRAVE) and des:IsType(TYPE_MONSTER) and rc:IsRelateToBattle() and rc:IsLevelAbove(10)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local damp=eg:GetFirst():GetPreviousControler()
	Duel.SetTargetPlayer(damp)
	Duel.SetTargetParam(400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,damp,400)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,v=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,v,REASON_EFFECT)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return (r&(REASON_EFFECT+REASON_DESTROY))==(REASON_EFFECT+REASON_DESTROY) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.qucon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,10000020)
end

function s.qufilter(c)
	return c:IsCode(10000000) and c:IsFaceup()
end
function s.qucon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.qufilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end