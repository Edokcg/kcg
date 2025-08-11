--Ｄ－フォース
local s, id = GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)	
	if not GhostBelleTable then GhostBelleTable={} end
	table.insert(GhostBelleTable,e1)

	--Cannot draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetRange(LOCATION_DECK)
	e2:SetTargetRange(1,0)
	e2:SetCondition(s.drcon1)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_DRAW_COUNT)
	e3:SetRange(LOCATION_DECK)
	e3:SetTargetRange(1,0)
	e3:SetCondition(s.drcon2)
	e3:SetValue(0)
	c:RegisterEffect(e3)
        
	--不受效果
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_DISABLE)
    e4:SetRange(LOCATION_DECK)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetCondition(s.sdcon2)
    c:RegisterEffect(e4)

	--disable and destroy
	local e5=Effect.CreateEffect(c) 
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e5:SetRange(LOCATION_DECK)
	e5:SetCode(EVENT_CHAIN_SOLVING)  
	e5:SetCondition(s.discon) 
	e5:SetOperation(s.disop) 
	c:RegisterEffect(e5) 

	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCode(EFFECT_CANNOT_DRAW)
	e9:SetRange(LOCATION_SZONE)
	e9:SetTargetRange(1,0)
	e9:SetCondition(aux.AND(s.plasmacon,s.drawcon))
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetCode(EFFECT_DRAW_COUNT)
	e10:SetRange(LOCATION_SZONE)
	e10:SetTargetRange(1,0)
	e10:SetCondition(s.plasmacon)
	e10:SetValue(0)
	c:RegisterEffect(e10)

	local e11=Effect.CreateEffect(c) 
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e11:SetRange(LOCATION_SZONE)
	e11:SetCode(EVENT_CHAIN_SOLVING)  
	e11:SetCondition(s.discon2) 
	e11:SetOperation(s.disop) 
	c:RegisterEffect(e11) 

	--ATK up,effect indestructible,and double attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCondition(s.plasmacon)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsCode,83965310))
	e6:SetValue(s.val)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetValue(aux.indoval)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_EXTRA_ATTACK)
	e8:SetValue(1)
	c:RegisterEffect(e8)	
end
s.listed_names={83965310}

function s.thfilter(c)
	return c:IsCode(83965310) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.DisableShuffleCheck(true)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.ConfirmCards(1-tp,sg)
	end
	c:CancelToGrave()
	local opt=Duel.SelectOption(tp, false, aux.Stringid(id,1), aux.Stringid(id,2))
	if opt==1 then
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
		c:ReverseInDeck()
	end
end

function s.drcon1(e)
	return s.drcon2(e) and Duel.GetCurrentPhase()==PHASE_DRAW
end
function s.drcon2(e)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(e:GetHandlerPlayer(),1)
	return g:GetFirst()==c and c:IsFaceup() and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end

function s.sdcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local g=Duel.GetDecktopGroup(c:GetControler(),1)
	return #g>0 and g:GetFirst()==c and c:IsFaceup()
end

function s.dfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()	
	local dc=Duel.GetDecktopGroup(tp,1)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)	
	return #dc>0 and dc:GetFirst()==c and c:IsFaceup()
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp~=tp
		and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g and g:IsExists(s.dfilter,1,nil,tp)
end
function s.discon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()	
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)	
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp~=tp
		and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g and g:IsExists(s.dfilter,1,nil,tp)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if ((re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.NegateActivation(ev))
		or (not re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.NegateEffect(ev)))
		and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end

function s.drawcon(e)
	return Duel.GetCurrentPhase()==PHASE_DRAW
end

function s.plasmacon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,83965310),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function s.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)*100
end